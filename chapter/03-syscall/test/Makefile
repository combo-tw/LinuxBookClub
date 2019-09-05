.PHONY: all check clean

CC = gcc
CFLAGS = -std=gnu99 -Wall -g

OBJS = factorial_ut.o
EXEC = factorial_ut

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

all: $(OBJS)
	$(CC) $^ -o $(EXEC)

check: $(EXEC)
	./$(EXEC)

clean:
	rm -f $(OBJS) factorial_ut

