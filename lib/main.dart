import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Algo ViZ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> randomHeights = [];
  List<String> allSortingAlgos = [
    'Insertion Sort',
    'Bubble Sort',
    'Selection Sort',
    'Merge Sort',
    'Heap Sort',
    'Quick Sort',
  ];
  int? currentlySelected = 1;
  bool? running = false;
  bool? asc = true;
  int delayInMs = 10;

  insertionSort(List<int> list) async {
    for (int j = 1; j < list.length; j++) {
      int key = list[j];

      int i = j - 1;

      while (i >= 0 && (asc! ? list[i] > key : list[i] < key)) {
        await Future.delayed(Duration(milliseconds: delayInMs));
        setState(() {
          list[i + 1] = list[i];
          i = i - 1;
          list[i + 1] = key;
        });
      }
    }
  }

  bubbleSort(List<int> list) async {
    for (int j = 1; j < list.length; j++) {
      int x = 0;
      for (int i = 0; i < list.length - j; i++) {
        await Future.delayed(Duration(milliseconds: delayInMs));
        if (asc! ? (list[i] > list[i + 1]) : (list[i] < list[i + 1])) {
          setState(() {
            int key = list[i + 1];
            list[i + 1] = list[i];
            list[i] = key;
            x = 1;
          });
        }
      }
      if (x == 0) {
        break;
      }
    }
  }

  selectionSort(List<int> list) async {
    for (int j = 0; j < list.length - 1; j++) {
      int min = j;
      for (int i = j + 1; i < list.length; i++) {
        await Future.delayed(Duration(milliseconds: delayInMs));
        if (asc! ? (list[i] < list[j]) : (list[i] > list[j])) {
          min = i;
          int key = list[j];
          setState(() {
            list[j] = list[min];
            list[min] = key;
          });
        }
      }
    }
  }

  mergeSort(List<int> list) async {
    int n = list.length;
    if (n < 2) {
      return list;
    }
    int midIndexOfList = (n / 2).floor();
    List<int> leftList = List.filled(midIndexOfList, 0);
    List<int> rightList = List.filled(n - midIndexOfList, 0);
    for (int i = 0; i < midIndexOfList; i++) {
      leftList[i] = list[i];
    }
    for (int i = midIndexOfList; i < n; i++) {
      rightList[i - midIndexOfList] = list[i];
    }
    mergeSort(leftList);
    mergeSort(rightList);
    await merge(leftList, rightList, list);
  }

  merge(leftList, rightList, list) async {
    int indexLeftList = leftList.length;
    int indexRightList = rightList.length;
    int i = 0;
    int j = 0;
    int k = 0;
    while (i < indexLeftList && j < indexRightList) {
      await Future.delayed(Duration(milliseconds: delayInMs));

      if (leftList[i] <= rightList[j]) {
        setState(() {
          list[k] = leftList[i];
        });
        i++;
      } else {
        setState(() {
          list[k] = rightList[j];
        });
        j++;
      }
      k++;
    }
    while (i < indexLeftList) {
      list[k] = leftList[i];
      i++;
      k++;
    }
    while (j < indexRightList) {
      list[k] = rightList[j];
      j++;
      k++;
    }
  }

  quickSort(List<int> list, int low, int high) async {
    if (low < high) {
      int pi = await partition(list, low, high);
      quickSort(list, low, pi - 1);
      quickSort(list, pi + 1, high);
    }
  }

  partition(List list, int low, int high) async {
    if (list == null || list.length == 0) return 0;
    int pivot = list[high];
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (asc! ? (list[j] <= pivot) : list[j] >= pivot) {
        i++;
        await swap(list, i, j);
      }
    }
    await swap(list, i + 1, high);
    return i + 1;
  }

  swap(List list, int i, int j) async {
    await Future.delayed(Duration(milliseconds: delayInMs));
    setState(() {
      int temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    });
  }

  void heapify(List list, int n, int i) {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    if (l < n && list[l] > list[largest]) {
      largest = l;
    }

    if (r < n && list[r] > list[largest]) {
      largest = r;
    }

    if (largest != i) {
      swapList(list, i, largest);
      heapify(list, n, largest);
    }
  }

  void swapList(List list, int i, int largest) {
    int swap = list[i];
    list[i] = list[largest];
    list[largest] = swap;
  }

  heapSort(List<int> list) async {
    int n = list.length;
    for (int i = (n ~/ 2); i >= 0; i--) {
      heapify(list, n, i);
    }

    for (int i = n - 1; i >= 0; i--) {
      await swapHeap(list, i);
      heapify(list, i, 0);
    }
  }

  swapHeap(List list, int i) async {
    await Future.delayed(Duration(milliseconds: delayInMs));
    setState(() {
      int temp = list[0];
      list[0] = list[i];
      list[i] = temp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    randomizeHeights();
    //insertionSort(randomHeights);
  }

  randomizeHeights() {
    randomHeights = [];
    for (var i = 0; i < 29; i++) {
      randomHeights.add(Random().nextInt(650));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          DropdownButton<int>(
            value: currentlySelected,
            iconEnabledColor: Colors.white,
            dropdownColor: Colors.black,
            underline: null,
            style: TextStyle(
              color: Colors.white,
            ),
            items: allSortingAlgos
                .map(
                  (e) => DropdownMenuItem<int>(
                    value: allSortingAlgos.indexOf(e) + 1,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (idx) {
              setState(() {
                currentlySelected = idx;
              });
            },
          ),
          ElevatedButton(
            onPressed: running!
                ? null
                : () async {
                    setState(() {
                      running = true;
                    });

                    if (currentlySelected == 1)
                      await insertionSort(randomHeights);
                    else if (currentlySelected == 2)
                      await bubbleSort(randomHeights);
                    else if (currentlySelected == 3)
                      await selectionSort(randomHeights);
                    else if (currentlySelected == 4)
                      await mergeSort(randomHeights);
                    else if (currentlySelected == 5)
                      await heapSort(randomHeights);
                    else if (currentlySelected == 6)
                      await quickSort(
                          randomHeights, 0, randomHeights.length - 1);
                    setState(() {
                      running = false;
                    });
                  },
            child: Text(
              'Start',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black54,
      body: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: randomHeights
                .map((e) => Expanded(
                      child: Bar(
                        height: e.toDouble(),
                      ),
                    ))
                .toList(),
          ),
          Container(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (asc!)
                          asc = false;
                        else
                          asc = true;
                      });
                    },
                    icon: Icon(
                      asc! ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                      color: Colors.white,
                    )),
                IconButton(
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      randomizeHeights();
                      running = false;
                    });
                  },
                  icon: Icon(Icons.refresh),
                ),
                Spacer(),
                Slider(
                  activeColor: Colors.grey,
                  inactiveColor: Colors.white,
                  value: delayInMs.toDouble(),
                  min: 5,
                  max: 100,
                  onChanged: (val) {
                    setState(() {
                      delayInMs = val.toInt();
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
