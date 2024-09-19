package com.example;

public class Main {
  public static void main(String[] args) {
    System.out.println(Main.class.getModule());
    System.out.println("Hello otherexample/com.example.Main");
	try {
		System.load("bla");
	} catch (Throwable e) {
	  // do nothing
	}
  }
}
