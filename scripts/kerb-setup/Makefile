.PHONY=all clean install
CONFIGS=core-site.xml hdfs-site.xml mapred-site.xml yarn-site.xml

all: $(CONFIGS)

install: clean all
	cp $(CONFIGS) ~/hadoop-tm-6-runtime/etc/hadoop

clean:
	-rm $(CONFIGS)

core-site.xml: ~/hadoop-conf/core-site.xml
	xsltproc --stringparam hostname `hostname -f` rewrite-hosts.xsl $^ | xmllint --format - > $@

hdfs-site.xml: ~/hadoop-conf/hdfs-site.xml
	xsltproc --stringparam hostname `hostname -f` rewrite-hosts.xsl $^ | xmllint --format - > $@

mapred-site.xml: ~/hadoop-conf/mapred-site.xml
	xsltproc --stringparam hostname `hostname -f` rewrite-hosts.xsl $^ | xmllint --format - > $@

yarn-site.xml: ~/hadoop-conf/yarn-site.xml
	xsltproc --stringparam hostname `hostname -f` rewrite-hosts.xsl $^ | xmllint --format - > $@


