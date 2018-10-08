#include <iostream>

using namespace std;

extern "C" int testf();

void main()
{
	int i;
	cout << testf() << endl;
	cin >> i;
}