all:
	g++ source.cpp subprojectfunctions.h subprojectfunctions.cpp -o subgitout
	
run:
	./subgitout
clean:
	rm subgitout
