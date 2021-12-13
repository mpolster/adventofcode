#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void parseInput (char * filename, long * fishes)  {

	FILE * file = fopen("input.txt", "r");
	if (file == NULL) exit(EXIT_FAILURE);

	char buffer[1025]; // hopefully enough 

	fscanf(file, "%s\n", buffer);

	if (ferror(file)) exit(EXIT_FAILURE);

	fclose(file);

	for (long i = 0; i < 9; ++i) fishes[i] = 0;

	char * tokens = strtok(buffer, ",");
	while (tokens) {
		fishes[atoi(tokens)]++;
		tokens = strtok(NULL, ",");
	}

}



long simulateNDays(long n, long * array) {

	for (long i = 0; i < n; ++i) {
		long buf = array[0];

		for (int i = 0; i < 8; i++) {
			array[i] = array[i+1];
			if (i == 6) array[6] += buf;
		}
		array[8] = buf;
	}

	long count = 0;
	for (long i = 0; i < 9; i++) count+=array[i];

	return count;
}



int main(void) {

	long * array = malloc(sizeof(long) * 9);
	if (array == NULL) return EXIT_FAILURE;

	parseInput("input.txt", array);
	long count80 = simulateNDays(80, array);

	parseInput("input.txt", array);
	long count256 = simulateNDays(256, array);

	printf("80: %ld, 256: %ld \n", count80, count256);

	free(array);
	
	return EXIT_SUCCESS;
}