public enum CoreError: Error {
  case network(Error)
  case parser(String)
  case other(String)
}
