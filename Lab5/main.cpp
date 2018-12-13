#include <iostream>

using namespace std;

extern "C" float nowy_exp(float x);

int main()
{
	float a;
	cin >> a;
	float ret = nowy_exp(a);
	cout << endl << ret << endl;
	return 0;
}