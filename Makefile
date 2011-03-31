CC=mxmlc

PFDemo.swf:
	$(CC) -debug=true src/PFDemo.as -output bin/$@

clean:
	rm -f bin/*.swf
