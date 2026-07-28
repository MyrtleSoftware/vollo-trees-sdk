all: vollo-example vollo-single-decision
      
CFLAGS += -std=c99 -O2 -flto -Wall -Wextra -Wpedantic -Wconversion

.PHONY: all clean

vollo-example: example.c npy.c npy.h utils.c utils.h
	$(CC) $^ $(CFLAGS) -I $(VOLLO_TREES_SDK)/include -L $(VOLLO_TREES_SDK)/lib -lvollo_rt -o vollo-example

vollo-single-decision: single-decision.c
	$(CC) single-decision.c $(CFLAGS) -I $(VOLLO_TREES_SDK)/include -L $(VOLLO_TREES_SDK)/lib -lvollo_rt -o vollo-single-decision

clean:
	rm -f vollo-example vollo-single-decision
