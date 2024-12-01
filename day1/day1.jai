// #import "Basic"()(MEMORY_DEBUGGER = true);
#import "Basic";
#import "File";
#import "Text_File_Handler";
#import "String";
#import "Sort";
#import "Math";
#import "Hash_Table";

main :: () {
    file_data, success := read_entire_file("input.txt");
    if !success {
        print("Error: Unable to load input.txt\n");
        return;
    }

    print("input.txt has % bytes.\n", file_data.count);

    print("------------------\n");
    print("Solution A: %\n", solution_a(file_data));
    print("------------------\n");
    print("Solution B: %\n", solution_b(file_data));

    free(file_data.data);

    // report_memory_leaks();
}

solution_a :: (input: string) -> int {
    list_a: [..]int;
    list_b: [..]int;

    // print("A\tB\n");
    while true {
        line, found := consume_next_line(*input);
        if !found break;

        // @Temporary
        if !line break;

        _, a, b := split_from_left(line, #char " ");
        a = eat_spaces(a);
        b = eat_spaces(b);

        val_a, _ := parse_int(*a);
        array_add(*list_a, val_a);

        val_b, _ := parse_int(*b);
        array_add(*list_b, val_b);
        // print("%\t%\n", val_a, val_b);
    }

    // print("\n\n");

    sorted_a := quick_sort(list_a, compare_ints);
    sorted_b := quick_sort(list_b, compare_ints);

    assert(sorted_a.count == sorted_b.count);

    count := sorted_a.count;
    sum: int;
    for 0..count-1 {
        a := sorted_a[it];
        b := sorted_b[it];
        // print("% - % = %\n", a, b, abs(a - b));
        sum += abs(a-b);
    }

    return sum;
}

solution_b :: (input: string) -> int {
    result: int;

    list_a: [..]int;
    list_b: [..]int;
    defer {
        free(list_a.data);
        free(list_b.data);
    }

    // print("A\tB\n");
    while true {
        line, found := consume_next_line(*input);
        if !found break;

        // @Temporary
        if !line break;

        _, a, b := split_from_left(line, #char " ");
        a = eat_spaces(a);
        b = eat_spaces(b);

        val_a, _ := parse_int(*a);
        array_add(*list_a, val_a);

        val_b, _ := parse_int(*b);
        array_add(*list_b, val_b);
        // print("%\t%\n", val_a, val_b);
    }

    b_counts: Table(int, int);
    init(*b_counts, list_b.count);
    defer deinit(*b_counts);

    for a, i: list_a {
        if table_contains(*b_counts, a) then continue;

        count: int;
        for b, j: list_b {
            if a == b then count += 1;
        }
        table_add(*b_counts, a, count);
    }

    for list_a {
        value, found := table_find(*b_counts, it);
        if !found then continue;
        // print("list_a[%]: % found % times in list_b\n% added to score\n", it_index, it, value, it * value);
        result += it * value;
    }

    return result;
}

compare_ints :: (a: int, b: int) -> int {
    delta := a - b;
    if delta < 0 return -1;
    if delta > 0 return  1;
    return 0;
}
