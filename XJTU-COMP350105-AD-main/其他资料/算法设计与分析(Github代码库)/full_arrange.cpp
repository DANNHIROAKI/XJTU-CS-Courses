#include<iostream>
using namespace std;

//find a full_arrange of a set of number
//
//if the first number of the array is
//different, then the array is different

int count = 0;

void my_swap(int *m,int *n)
{
    int temp = *m;
    *m = *n;
    *n = temp;
}

void perm(int list[], int m, int n)
{
    if(m==n)
    {
        //only one number left, print
        //them
        count++;
        cout << list[0];
        for (int i = 1; i < m; i++)
        {
            cout << " " << list[i];
        }
        cout << endl;
    }
    else
    {
        for (int i = m; i < n;i++)
        {
            //put one number in the head and
            //arrange other numbers(in recursion)
            my_swap(&list[m], &list[i]);
            perm(list, m + 1, n);
            my_swap(&list[m], &list[i]);
        }
    }
}

int main()
{
    int list[] = {1, 2, 3, 4, 5};
    perm(list, 0, 5);
    cout << count << " in total." << endl;
    return 0;
}