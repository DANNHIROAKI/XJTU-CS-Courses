#include<iostream>
using namespace std;

//the complexity of merge-sort is O(NlgN), 
//no matter the best, the worst or on average

//the copy of the original arrary
int array_c[1000] = {0};

void merge_sort(int[], int);
void merge(int[], int, int, int);

int main()
{
    int array[] = {8, 10, 7, 6, 5, 5, 5, 4, 3, 2, 2, 1};
    int N = sizeof(array) / sizeof(array[0]);
    merge_sort(array, N);
    for (int i = 0; i < N; i++)
        cout << array[i] << " ";
    return 0;
}

void merge_sort(int array[], int N)
{
    for (int size = 1; size < N; size*=2)
    {
        //size: the size of the array each time compared
        //every time the size doubled because of merging
        //this loop works log2^N times
        for (int low = 0; low < N - size; low += size*2)
        {
            //low: the index of the first number in each
            //merge
            merge(array, low, low + size - 1, min(low + size * 2 - 1, N - 1));
        }
    }
}

void merge(int array[], int low, int middle, int high)
{
    //compare&merge array[low,middle] and 
    //array[middle+1,high]

    //pointers of subarrary
    int j = low, k = middle + 1;
    //copy original arrary
    for (int i = low; i <= high; i++)
        array_c[i] = array[i];
    for (int i = low; i <= high; i++)
    {
        if (j > middle)
        {
            //left part is empty
            array[i] = array_c[k];
            k++;
        }
        else if (k > high)
        {
            //right part is empty
            array[i] = array_c[j];
            j++;
        }
        else if(array_c[j]>=array_c[k])
        {
            //both are not empty, right part is smaller
            array[i] = array_c[k];
            k++;
        }
        else
        {
            //both are not empty, left part is smaller
            array[i] = array_c[j];
            j++;
        }   
    }
}