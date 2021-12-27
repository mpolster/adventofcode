#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>

#define STEPS 100

typedef struct {
	int x;
	int y;
	int energy_level;
	bool has_flashed;
} Octopus;

typedef struct {
	Octopus field [10][10];
} Field;

void octopus_create(Octopus* octopus, int x, int y, int energy_level) {
	if (!octopus) {
		fprintf(stderr, "Error in octopus_create: Parameter octopus is NULL!");
		exit(1);
	}
	octopus->x = x;
	octopus->y = y;
	octopus->energy_level = energy_level;
	octopus->has_flashed = false;
}

bool octopus_can_flash(Octopus* octopus) {
	return octopus->energy_level > 9 && !octopus->has_flashed;
}

// increase energy level of all adjacent octopuses by 1
void octopus_flash(Field* field, Octopus* octopus) {

	int x = octopus->x;
	int y = octopus->y;

	if (x+1 < 10 && y+1 < 10) field->field[x+1][y+1].energy_level++;
	if (x+1 < 10 && y+0 < 10) field->field[x+1][y].energy_level++;
	if (x+1 < 10 && y-1 >= 0) field->field[x+1][y-1].energy_level++;
	if (x+0 < 10 && y+1 < 10) field->field[x][y+1].energy_level++;
	if (x+0 < 10 && y-1 >= 0) field->field[x][y-1].energy_level++;
	if (x-1 >= 0 && y+1 < 10) field->field[x-1][y+1].energy_level++;
	if (x-1 >= 0 && y+0 < 10) field->field[x-1][y].energy_level++;
	if (x-1 >= 0 && y-1 >= 0) field->field[x-1][y-1].energy_level++;
	octopus->has_flashed = true;

}

// play a round...
int play_round(Field * field) {

	// at first increase energy level of every octopus by one
	for (int i = 0; i < 10; ++i) {
		for (int j = 0; j < 10; ++j) {
			field->field[i][j].energy_level++;
		}
	}

	// flash octopusses until no one can flash
	bool changes = false;
	int flashes = 0;

	do {
		changes = false;
		for (int i = 0; i < 10; ++i) {
			for (int j = 0; j < 10; ++j) {
				if (octopus_can_flash(&field->field[i][j])) {
					octopus_flash(field, &field->field[i][j]);
					flashes++;
					changes = true;
				}
			}
		}
	} while(changes);

	// reset has_flashed for next round
	for(int i = 0; i < 10; ++i) {
		for (int j = 0; j < 10; ++j) {
			if (field->field[i][j].has_flashed) {
				field->field[i][j].has_flashed = false;
				field->field[i][j].energy_level = 0;
			}
		}
	}
	return flashes;
}

void read_field_from_file(Field* field, char* filename) {
	FILE * file = fopen(filename, "r");

	if (!file) {
		fprintf(stderr, "Error in read_field_from_file: file input failed!");
		exit(1);
	}

	int c = 0, x = 0, y = 0;

	while (true) {
		c = fgetc(file);

		if (c == EOF) break;
		if ( (char) c == '\n') {
			y++;
			x = 0;
			continue;
		}
		octopus_create(&field->field[x][y], x, y,  c - '0');

		x++;

	}
	fclose(file);
}

void part1() {
	Field *field = malloc(sizeof(Field));

	if (field == NULL) {
		fprintf(stderr, "Error: Not enough memory!\n");
		exit(1);
	}

	read_field_from_file(field, "input.txt");
	int number_of_flashes = 0;

	for (int i = 0; i < STEPS; i++) {
		number_of_flashes += play_round(field);
	}

	printf("Number of Flashes: %d\n", number_of_flashes);

	free(field);
}

void part2() {
	Field *field = malloc(sizeof(Field));

	if (field == NULL) {
		fprintf(stderr, "Error: Not enough memory!\n");
		exit(1);
	}

	read_field_from_file(field, "input.txt");

	int round = 0;
	while(true) {
		round++;
		if (play_round(field) == 100) break;
	}

	printf("First synchronous flash in round: %d\n", round);

	free(field);
}

int main(void) {

	part1();
	part2();

	return 0;
}