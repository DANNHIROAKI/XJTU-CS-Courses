#include<iostream>
using namespace std;

void quick_sort(int[], int, int);
int partition(int[], int, int);
void exchange(int*, int, int);

int main()
{
    int array[] = {7, 5, 6, 3, 1, 2, 9, 14, 64, 22};
    int len = sizeof(array) / sizeof(int);
    quick_sort(array, 0, len - 1);
    for (int i = 0; i < len; i++)
        cout << array[i]<<" ";
    return 0;
}

void quick_sort(int array[], int low, int high)
{
    if (low >= high)
        return;
    int j = partition(array, low, high);

    //divide-and-conquer

    quick_sort(array, low, j - 1);
    quick_sort(array, j + 1, high);
}

int partition(int array[],int low,int high)
{
    //return the number that is in the right position,
    //which means left part is smaller than it and right
    //part is bigger than it

    //since v is the first number, i should be array[low+1]

    int i = low+1, j = high;
    int v = array[low];
    while(1)
    {
        while(array[i]<v)
        {
            i++;
            if(i==high)
                break;
        }
        while(array[j]>v)
        {
            j--;
            if(j==low)
                break;
        }
        
        //Now, array[i] is bigger than v and array[j] is 
        //smaller than v. And array[low+1..i-1] are all 
        //smaller than v, same situcation for array[j+1
        //..high].

        if(i>=j)
            break;
        exchange(array, i, j);
    }

    //move array[j] to the right position

    exchange(array, low, j);

    //return j to devide array

    return j;
}

void exchange(int *array,int i,int j)
{
    int temp = *(array+i);
    *(array+i) = *(array+j);
    *(array+j) = temp;
}