class Environment {
  final String secret;
  Environment(this.secret);
}

class EnvironmentValue {
  static final Environment development = Environment('Development');
  static final Environment production = Environment('Production');
}
