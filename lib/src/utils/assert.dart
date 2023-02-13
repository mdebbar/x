void prodAssert(bool condition, String message) {
  if (!condition) {
    throw AssertionError(message);
  }
}
