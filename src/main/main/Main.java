package main;

public class Main {
  public static void main(String[] args) {
    System.out.println(Main.class.getModule());
    com.example.Main.main(args);
  }
}

