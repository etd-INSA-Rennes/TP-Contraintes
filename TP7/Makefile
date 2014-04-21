CPATHS = choco.jar:.

JFLAGS = -g -cp $(CPATHS)
JC     = javac
JAVA   = java

RM     = rm

all: run
	
VisuMobile.class: VisuMobile.java Mobile.class
	$(JC) $(JFLAGS) $<

Mobile.class: Mobile.java
	$(JC) $(JFLAGS) $<

run: VisuMobile.class
	$(JAVA) -cp choco.jar:. VisuMobile

clean:
	$(RM) *.class
