#include <stdio.h>
#include <stdlib.h>

void imprime(int n) {
  if (n < 0) {
      exit(1);
  }
  printf("numero = %d\n", n);
  imprime(n-1);
}

int main() {
  imprime(5);

  return 0;
}
