# proc trace
## Run a process and iterate over every instruction evaluated

```py
# example code to print every instruction address:
for rip in Tracer(['/bin/echo', 'hello']).step_through():
	print(rip)
```


### How to run
```bash
$ make # build the example program
$ ./trace.py ./foo # trace the example program
```
