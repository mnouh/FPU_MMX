#include <stdio.h>

#include "show.h"

int main() {
//Testing Cases
  int size = 0;

  char bufferZ[1024] = {};		
  char buffer[1024] = {'H','e', 'l', 'l', 'o', 'w', 'o', 'r', 'l', 'd'};	
  char buffer1[1024] = {'a','d', 'l', 'f', 'u', 'w', 'o', 'r', 'c', 'b', 'a', 'd'};
  char buffer2[1024] = {'c','m', 'n', 'o', 'p', 'b', 'a', 'c', 'l', 'd', 'b', 'p', 'n', 'O', 'C', 'D', 'l', 'c', 'q', 'R', 's', 'T', 'c', 'a'};
  char buffer3[1024] = {'1','2', '3', '4', '5', '6', '7', '8', '8', '7', '6', '5', '4', '3', '2', '1'};
  char buffer4[1024] = {'b','c', '1', '2', 'c', 'f', 'b', 'l', '2', '1','c', '1', '2', 'c', 'f', 'b', 'l', '2', '1','c', '1', '2', 'c', 'f', 'b', 'l', '2', '1','c', '1', '2', 'c', 'f', 'b', 'l', '2', '1','c', '1', '2', 'c', 'f', 'b', 'l', '2', '1','c', '1', '2', 'c', 'f', 'b', 'l', '2', '1'};		
//  printf("Enter a phrase: ");

  //scanf("%1023[^\n\r]", buffer);
//Test 1
  printf("Enter a Phrase: %s\n", buffer);
  printf("You entered:");

  size = show_string(buffer);

  printf("\nSize: %d\n", size);
//Test 2
  printf("Enter a Phrase: %s\n", buffer1);
  printf("You entered:");

  size = show_string(buffer1);
	
  printf("\nSize: %d\n", size);
//Test 3
  printf("Enter a Phrase: %s\n", buffer2);
  printf("You entered:");

  size = show_string(buffer2);
	
  printf("\nSize: %d\n", size);
//Test 4
  printf("Enter a Phrase: %s\n", buffer3);
  printf("You entered:");

  size = show_string(buffer3);
	
  printf("\nSize: %d\n", size);
//Test 5
printf("Enter a Phrase: %s\n", buffer4);
  printf("You entered:");

  size = show_string(buffer4);
	
  printf("\nSize: %d\n", size);
//Test 6 ZERO
  printf("Enter a Phrase: %s\n", bufferZ);
  printf("You entered:");

  size = show_string(bufferZ);
	
  printf("\nSize: %d\n", size);
	
  return 0;
  }
