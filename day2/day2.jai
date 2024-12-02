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

    // print("------------------\n");
    // print("Part 1: %\n", part_one(file_data));
    print("------------------\n");
    print("Part 2: %\n", part_two(file_data));
    print("------------------\n");

    free(file_data.data);

    // report_memory_leaks();
}

part_one :: (input: string) -> int {
    result: int;

    while true {
        line, found := consume_next_line(*input);
        if !found || !line break;

        level_strings := split(line, " ");
        levels: [..]int;
        for * level_strings {
            array_add(*levels, parse_int(it));
        }

        is_safe: bool = true;

        prev_level := levels[0];
        prev_delta_sign: int = sign(levels[1] - levels[0]);
        for levels {
            // print("%, ", it);

            if it_index == 0 then continue;

            delta := it - prev_level;
            if abs(delta) == 0 || abs(delta) > 3 {
                is_safe = false;
                break;
            }

            if prev_delta_sign != sign(delta) {
                is_safe = false;
                break;
            }

            prev_delta_sign = sign(delta);
            prev_level = it;
        }

        if is_safe {
            print("is safe\n");
            result += 1;
        } else {
            print("unsafe\n");
        }
    }

    return result;
}

part_two :: (input: string) -> int {
    result: int;

    while true {
        line, found := consume_next_line(*input);
        if !found || !line break;

        level_strings := split(line, " ");
        levels: [..]int;
        for * level_strings {
            array_add(*levels, parse_int(it));
        }

        errors := check_levels(levels);

        if errors > 0 {
            for 0..levels.count-1 {
                errors = check_levels(levels, it);
                if errors == 0 then break;
            }
        }

        if errors == 0 {
            print("% is safe.\n", levels);
            result += 1;
        } else {
            print("% is unsafe with % errors.\n", levels, errors);
        }
    }

    return result;
}


check_levels :: (levels: [..]int, skip_index: int = -1) -> (error_count: int) {
    prev_delta_sign: int = 0;
    errors: int = 0;

    for levels {
        if it_index == skip_index then continue;
        // print("% ", it);

        next_index := it_index+1;
        if next_index == skip_index then next_index += 1;
        if next_index >= levels.count then break;


        next_level := levels[next_index];

        delta := next_level - it;
        if abs(delta) == 0 || abs(delta) > 3 || (prev_delta_sign != sign(delta) && prev_delta_sign != 0) {
            errors += 1;
            continue;
        }

        prev_delta_sign = sign(delta);
    }
    // print("errors: %\n", errors);

    return errors;
}

sign :: (x: s64) -> s64 {
    if x > 0 then return  1;
    if x < 0 then return -1;
    return 0;
}
