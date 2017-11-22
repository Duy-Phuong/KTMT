#include <iostream>
using namespace std;
#include <string>

int main()
{
	string s;
	while (1)
	{
		cout << "\n-----keygen-----\n";
		do
		{
			cout << "nhap user name(so ki tu <= 10): " << endl;
			fflush(stdin);
			getline(cin, s);
			if (s.length() > 10)
			{
				cout << "\nmoi ban nhap lai user name (so ki tu nho hon 10):" << endl;
			}
		} while (s.length() > 10);

		int p = 0;
		for (int i = 0; i < s.length(); i++)
		{
			if (s[i] >= 'a' && s[i] <= 'z')
			{
				s[i] -= 32;
			}
			p += s[i];
		}
		p = p ^ 22136;// tuong duong xor voi 5678 trong hex
		int c = 4660;// tuong duong voi 1234 trong hex
		int pass = 0;
		pass = p^c;
		cout << "pass la: ";
		cout << pass << endl;
	}
	return 0;
}