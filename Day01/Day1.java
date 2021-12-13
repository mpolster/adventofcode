import java.util.*;
import java.io.*;
public class Day1 {
	
	public static void main(String [] args){

		// Stuff needed for both parts
		List<Integer> lines = new ArrayList<>();
		try (BufferedReader fr = new BufferedReader(new FileReader("input.txt")))  {
			String line = null;
			while((line = fr.readLine()) != null) {
				lines.add(Integer.parseInt(line));
			}
		} catch (IOException ioex) {
			ioex.printStackTrace();
		}

		// Part 1
		System.out.println("increments: " + incrementsF(lines));

		// Part 2 Sliding Window
		List<Integer> tripleSums = tripleSums(lines);
		System.out.println("increments sliding window: " + incrementsF(tripleSums));

	}

	public static List<Integer> tripleSums(List<Integer> lines) {
		List<Integer> tripleSums = new ArrayList<>();
		for (int i = 0; i < lines.size() - 2; i++) {
			tripleSums.add(lines.get(i) + lines.get(i+1) + lines.get(i+2));
		}
		return tripleSums;
	}

	public static int incrementsF(List<Integer> list) {
		int increments = 0;
		for (int i = 1; i < list.size(); i++) {
			if (list.get(i) > list.get(i-1)) increments++;
		}
		return increments;
	}
}