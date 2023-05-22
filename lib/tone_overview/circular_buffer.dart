class CircularBuffer<T> {
  final List<T?> buffer;
  int readIndex = 0;
  int writeIndex = 0;
  bool isFull = false;

  CircularBuffer(int capacity) : buffer = List<T?>.filled(capacity, null);

  void add(T element) {
    buffer[writeIndex] = element;

    writeIndex = (writeIndex + 1) % buffer.length;
    if (writeIndex == readIndex) {
      readIndex = (readIndex + 1) % buffer.length;
      isFull = true;
    }
  }

  Iterable<T?> getElements() sync* {
    if (isFull) {
      for (int i = readIndex; i < buffer.length; i++) {
        yield buffer[i];
      }
    }
    for (int i = 0; i < writeIndex; i++) {
      yield buffer[i];
    }
  }
}
