package main;

import java.lang.module.Configuration;
import java.lang.module.ModuleFinder;
import java.lang.reflect.Method;
import java.nio.file.Path;
import java.util.Set;

public class Main {
  public static void main(String[] args) {
    try {
        System.out.println(Main.class.getModule());
        com.example.Main.main(args);
        // module layer
        ModuleFinder finder = ModuleFinder.of(Path.of("."));
        ModuleLayer parent = ModuleLayer.boot();
        Configuration cf = parent.configuration().resolve(finder, ModuleFinder.of(), Set.of("otherexample"));
        ClassLoader scl = ClassLoader.getSystemClassLoader();
        ModuleLayer layer = parent.defineModulesWithOneLoader(cf, scl);
        Class<?> c = layer.findLoader("otherexample").loadClass("com.example.Main");
        Method main = c.getMethod("main", String[].class);
        main.invoke(null, (Object) args);
      } catch (ReflectiveOperationException e) {
          throw new RuntimeException(e);
      }
  }
}

