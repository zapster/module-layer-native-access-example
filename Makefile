PHONY: all clean
MODULE_PATH=

all: example.jar main.jar


src/main/Main.class: JAVAC_ARGS=--module-path example.jar
src/main/Main.class: example.jar

example.jar: src/module/com/example/Main.class src/module/module-info.class
main.jar: src/main/Main.class src/main/module-info.class

%.jar:
	jar --create --file $@ $^

src/module/%.class: src/module/%.java
	javac --source-path src/module $< $(JAVAC_ARGS)

src/main/%.class: src/main/%.java
	javac --source-path src/main $< $(JAVAC_ARGS)

clean:
	find . -name *.jar -delete
	find . -name *.class -delete
