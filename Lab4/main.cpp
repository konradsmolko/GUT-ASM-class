#include <iostream>

using namespace std;

extern "C" int szukaj_max(int x, int y, int z);
extern "C" int szukaj4_max(int a, int b, int c, int d);
extern "C" int substitute(char* str, char w, char c);
extern "C" void odejmij_jeden(int** liczba);

int main()
{
	// Zadanie 4.1
	cout << szukaj4_max(66, 3, 2, 23) << endl;
	// Zadanie 4.3
	int k;
	int* wsk = &k;
	scanf_s("%i", &k);
	odejmij_jeden(&wsk);
	cout << k << endl;
	// Zadanie dodatkowe
	char str[128];
	char w, c;
	scanf_s("%s", str, 128);
	scanf_s(" %c", &w, 1);
	scanf_s(" %c", &c, 1);
	cout << substitute(str, w, c) << endl;

	return 0;
}