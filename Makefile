# Mohamed Nouh

all: repeat repeat2 repeat3 repeat4 repeat5 repeat6 test test2 test3 test4 test5 test6


show.o: show.c
	gcc -Wall -m32 -c show.c -o show.o

repeat.o: repeat.c
	gcc -Wall -m32 -c repeat.c -o repeat.o

show2.o: show2.s
	gcc -Wall -m32 -c show2.s -o show2.o

repeat: repeat.o show.o
	gcc -Wall -m32 show.o repeat.o -o repeat

repeat2: show2.o repeat.o
	gcc -Wall -m32 show2.o repeat.o -o repeat2

show3.o: show3.s
	gcc -Wall -m32 -c show3.s -o show3.o

repeat3: show3.o repeat.o
	gcc -Wall -m32 show3.o repeat.o -o repeat3

show4.o: show4.s
	gcc -Wall -m32 -c show4.s -o show4.o

repeat4: show4.o repeat.o
	gcc -Wall -m32 show4.o repeat.o -o repeat4

show5.o: show5.s
	gcc -Wall -m32 -c show5.s -o show5.o

repeat5: show5.o repeat.o
	gcc -Wall -m32 show5.o repeat.o -o repeat5

show6.o: show6.s
	gcc -Wall -m32 -c show6.s -o show6.o

repeat6: show6.o repeat.o
	gcc -Wall -m32 show6.o repeat.o -o repeat6

test.o: test.c
	gcc -Wall -m32 -c test.c -o test.o

test: test.o show.o
	gcc -Wall -m32 show.o test.o -o test

test2.o: test.c
	gcc -Wall -m32 -c test.c -o test2.o

test2: test2.o show2.o
	gcc -Wall -m32 show2.o test2.o -o test2

test3.o: test.c
	gcc -Wall -m32 -c test.c -o test3.o

test3: test3.o show3.o
	gcc -Wall -m32 show3.o test3.o -o test3

test4.o: test.c
	gcc -Wall -m32 -c test.c -o test4.o

test4: test4.o show4.o
	gcc -Wall -m32 show4.o test4.o -o test4
test5.o: test.c
	gcc -Wall -m32 -c test.c -o test5.o

test5: test5.o show5.o
	gcc -Wall -m32 show5.o test5.o -o test5

test6.o: test.c
	gcc -Wall -m32 -c test.c -o test6.o

test6: test6.o show6.o
	gcc -Wall -m32 show6.o test6.o -o test6

clean:
	rm -f *.o repeat.s show.s repeat repeat2 repeat3 repeat4 repeat5 repeat6 test test2 test3 test4 test5 test6

