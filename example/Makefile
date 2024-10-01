all: vollo-example vollo-single-decision
      
CFLAGS = -Wall -Wextra -Wpedantic -Wconversion

.PHONY: all clean

vollo-example: example.c npy.h utils.h
	$(CC) example.c -O2 -std=gnu11 $(CFLAGS) -I $(VOLLO_TREES_SDK)/include -L $(VOLLO_TREES_SDK)/lib -lvollo_rt -o vollo-example

vollo-single-decision: single-decision.c
	$(CC) single-decision.c -O2 -std=gnu11 $(CFLAGS) -I $(VOLLO_TREES_SDK)/include -L $(VOLLO_TREES_SDK)/lib -lvollo_rt -o vollo-single-decision

clean:
	rm -f vollo-example vollo-single-decision
