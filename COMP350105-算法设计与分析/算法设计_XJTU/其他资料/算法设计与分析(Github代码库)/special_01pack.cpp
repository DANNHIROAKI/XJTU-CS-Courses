#include<iostream>
using namespace std;

int find_min(int pack[][2], int n)
{
    //return the min_wight item's index
    int min = pack[0][0];
    int p = 0;
    for (int i = 1; i < n;i++)
    {
        if(pack[i][0]<min)
        {
            min = pack[i][0];
            p = i;
        }
    }
    return p;
}

void greedyselect(int pack[][2], int n, int c)
{
    int sum_w = 0, sum_v = 0;
    int min;
    cout << "Choosen item number:" << endl;
    while (sum_w < c)
    {
        min = find_min(pack, n);
        if (sum_w + pack[min][0] <= c)
        {
            //package is big enough to load
            sum_v += pack[min][1];
            cout << min << " ";            
        }
        sum_w += pack[min][0];
        pack[min][0] = 9999;//mark this item that it's already loaded
    }
    cout<<"\nThe max value is "<<sum_v<<endl;
}

int main()
{
    int n = 5, c = 12;
    int pack[n][2] = {{3, 8}, {1, 10}, {4, 7}, {2, 9}, {5, 6}};
    greedyselect(pack, n, c);
    return 0;
}