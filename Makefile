.PHONY: all clean run run-agent run-native

CONFIG_DIR=./config-dir
ALL_ARTIFACTS: example.jar example2.jar main.jar


all: ${ALL_ARTIFACTS}


src/main/main/Main.class: JAVAC_ARGS=--module-path example.jar
src/main/main/Main.class: example.jar
src/main/module-info.class: JAVAC_ARGS=--module-path example.jar
src/main/module-info.class: example.jar

main.jar: src/main/main/Main.class src/main/module-info.class
	jar --create --file $@ -C src/main main/Main.class -C src/main module-info.class

example.jar: src/module/com/example/Main.class src/module/module-info.class
	jar --create --file $@ -C src/module com/example/Main.class -C src/module module-info.class

example2.jar: src/module2/com/example/Main.class src/module2/module-info.class
	jar --create --file $@ -C src/module2 com/example/Main.class -C src/module2 module-info.class

src/module/%.class: src/module/%.java
	javac --source-path src/module $< $(JAVAC_ARGS)

src/module2/%.class: src/module2/%.java
	javac --source-path src/module2 $< $(JAVAC_ARGS)

src/main/%.class: src/main/%.java
	javac --source-path src/main $< $(JAVAC_ARGS)

run: all
	java --module-path example.jar:main.jar --enable-native-access example --enable-native-access main --module main/main.Main

run-agent: ${CONFIG_DIR}/reachability-metadata.json

${CONFIG_DIR}/reachability-metadata.json: ${ALL_ARTIFACTS}
	test -n "${GRAALVM_HOME}"
	${GRAALVM_HOME}/bin/java -agentlib:native-image-agent=config-output-dir=${CONFIG_DIR} --module-path example.jar:main.jar --enable-native-access example --enable-native-access main --module main/main.Main

run-native: main.main
	./$<

main.main: ${CONFIG_DIR}/reachability-metadata.json
	test -n "${GRAALVM_HOME}"
	${GRAALVM_HOME}/bin/native-image -H:ConfigurationFileDirectories=${CONFIG_DIR} --module-path example.jar:main.jar --enable-native-access example --enable-native-access main --module main/main.Main -o $@

clean:
	-find . -name "*.jar" -delete
	-find . -name "*.class" -delete
	-rm -rf main.main
	-rm -rf ${CONFIG_DIR}
