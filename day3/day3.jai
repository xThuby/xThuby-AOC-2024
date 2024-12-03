// #import "Basic"()(MEMORY_DEBUGGER = true);
#import "Basic";
#import "File";
#import "Text_File_Handler";
#import "String";
#import "Math";

main :: () {
    file_data, success := read_entire_file("input.txt");
    if !success {
        print("Error: Unable to load input.txt\n");
        return;
    }

    print("input.txt has % bytes.\n", file_data.count);

    print("------------------\n");
    print("Part 1: %\n", part_one(file_data));
    print("------------------\n");
    print("Part 2: %\n", part_two(file_data));
    print("------------------\n");

    free(file_data.data);

    // report_memory_leaks();
}

part_one :: (input: string) -> int {
    result: int;

    while true {
        if begins_with(input, "mul") {
            advance(*input, 3);
            if input[0] == #char "(" {
                advance(*input);
                found_closing_paren := false;
                closing_paren_index: int;
                for #v2 < 0..8 {
                    if input[it] == #char ")" {
                        found_closing_paren = true;
                        closing_paren_index = it;
                    }
                }

                if closing_paren_index != 0 {
                    numbers := slice(input, 0, closing_paren_index);
                    the_split := split(numbers, ",");
                    defer free(the_split.data);
                    a: int;
                    b: int;
                    if the_split.count == 2 {
                        a = parse_int(*eat_spaces(the_split[0]));
                        b = parse_int(*eat_spaces(the_split[1]));
                    }
                    // print("% * % = %\n", a, b, a * b);
                    result += a * b;
                }
            }
        }

        if input.count == 0 then break;
        advance(*input);
    }

    return result;
}

part_two :: (input: string) -> int {
    result: int;

    enabled := true;

    while true {
        if begins_with(input, "don't()") {
            enabled = false;
        } else if begins_with(input, "do()") {
            enabled = true;
        }

        if begins_with(input, "mul") && enabled {
            advance(*input, 3);
            if input[0] == #char "(" {
                advance(*input);
                found_closing_paren := false;
                closing_paren_index: int;
                for #v2 < 0..min(8, input.count-1) {
                    if input[it] == #char ")" {
                        found_closing_paren = true;
                        closing_paren_index = it;
                    }
                }

                if closing_paren_index != 0 {
                    numbers := slice(input, 0, closing_paren_index);
                    the_split := split(numbers, ",");
                    defer free(the_split.data);
                    a: int;
                    b: int;
                    if the_split.count == 2 {
                        a = parse_int(*eat_spaces(the_split[0]));
                        b = parse_int(*eat_spaces(the_split[1]));
                    }
                    result += a * b;
                }
            }
        }

        if input.count == 0 then break;
        advance(*input);
    }

    return result;
}

