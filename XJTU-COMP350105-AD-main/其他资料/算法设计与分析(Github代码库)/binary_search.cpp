#include<iostream>
using namespace std;

//divide-and-conquer
//binary-search

int binary_search(int*, int, int);

int main()
{
    int array[] = {1, 3, 5, 7, 9};
    int len = sizeof(array) / sizeof(int);
    int index = binary_search(array, 9, len);
    cout << index << endl;
    return 0;
}

int binary_search(int array[], int key, int len)
{
    //array is an array which is sorted
    //key is the number expected to find
    //len is the array's length

    int head = 0, tail = len - 1;
    while (head<=tail)
    {
        int middle = (head + tail) / 2;
        if(key==array[middle])
        {
            //find the key successfully
            return middle;
        }
        else if(key<array[middle])
        {
            //find key in the former part
            tail = middle-1;
        }
        else
        {
            //find key in the latter part
            head = middle + 1;
        }
    }
        //failed to find the key
        return -1;
}