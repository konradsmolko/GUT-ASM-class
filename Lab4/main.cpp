#include <iostream>

using namespace std;

extern "C" int szukaj_max(int x, int y, int z);
extern "C" int szukaj4_max(int a, int b, int c, int d);
extern "C" int substitute(char* str, char w, char c);

int main()
{
	char str[128];
	char w, c;

	cout << szukaj4_max(1, 1, 3, 4) << endl; // ZROBIC 4.3
	scanf_s("%s", str, 128);
	scanf_s(" %c", &w, 1);
	scanf_s(" %c", &c, 1);

	cout << substitute(str, w, c) << endl;
	return 0;
}