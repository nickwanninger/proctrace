#!/usr/bin/env python3
import ptrace.debugger
import signal
import subprocess
import sys
from ptrace.debugger.child import createChild
import os
from ptrace.binding import ptrace_traceme
from capstone import *



def waitpid_no_intr(pid, options):
    """Like os.waitpid, but retries on EINTR"""
    while True:
        try:
            return os.waitpid(pid, options)
        except OSError as e:
            if e.errno == EINTR:
                continue
            else:
                raise


class Tracer:
    def __init__(self, args):
        self.pid = os.fork()

        if self.pid == 0:
            ptrace_traceme()
            os.execvp(args[0], args)
            os.exit(0)

        self.tracer = ptrace.debugger.PtraceDebugger()
        # wait for the pid, I guess
        # waitpid_no_intr(self.pid, 0)
        self.process = self.tracer.addProcess(self.pid, True)


    def single_step(self):
        self.process.singleStep()
        self.process.waitSignals(signal.SIGTRAP)

    def detach(self):
        self.process.detach()
        self.tracer.quit()


    def syscall(self):
        self.process.syscall()
        self.tracer.waitSyscall()


    def reg(self, name):
        return self.process.getreg(name);


    def mem(self, addr, size):
        return self.process.readBytes(addr, size)

    def regs(self):
        return self.process.getregs();

    def dump_regs(self, out=None):
        cb = None
        if out is not None:
            cb = lambda o: out.write(o + '\n')

        self.process.dumpRegs(cb)


    def each_instruction(self, interval = 1):
        i = 0
        while True:
            try:
                if i == 0:
                    yield self.reg('rip')

                self.single_step()

                i += 1
                if i == interval:
                    i = 0
                # print(hex(t.reg('rip'));
            except ptrace.debugger.ProcessExit:
                break;

    def each_syscall(self):
        while True:
            try:
                yield self.reg('rip')
                self.syscall()
            except ptrace.debugger.ProcessExit:
                break;




    def decompile(self, rip):
        try:
            md = Cs(CS_ARCH_X86, CS_MODE_64)
            code = self.mem(rip, 16)
            return next(md.disasm(code, rip))
        except:
            return None

    def dump_instruction(self):
        insn = self.decompile(self.reg('rip'))
        if insn is not None:
            print("{:010x}     {} {}".format(insn.address, insn.mnemonic, insn.op_str))


# just all the registers
reg_names = [
    'rax', 'rbx', 'rcx', 'rdx', 'rsi', 'rdi',
    'rip', 'rsp', 'rbp', 'r10',
    'r11', 'r12', 'r13', 'r14', 'r15',
    'r9', 'r8', 'eflags'
]


def trace_to_csv(argv, dst, interval=1):

    with open(dst, 'w') as f:
        # write the CSV header
        f.write('ind, ')
        f.write(', '.join(reg_names) + '\n')

        tracer = Tracer(argv)
        i = 0
        for rip in tracer.each_instruction(interval):
            # tracer.dump_instruction()
            # insn = tracer.decompile(tracer.reg('rip'))
            # if insn is not None and insn.mnemonic == 'syscall':
                # tracer.dump_instruction()
            f.write(str(i) + ', ')
            f.write(', '.join(f'{tracer.reg(reg)}' for reg in reg_names) + '\n')
            i += 1


def main():
    trace_to_csv(sys.argv[1:], "trace.csv", interval=1)



if __name__ == "__main__":
    main()
