#import "Basic";
#import "Compiler";
#import "File";
#import "File_Utilities";

#run {
    set_build_options_dc(.{do_output = false});

    build_output_directory := "out";

    make_directory_if_it_does_not_exist(build_output_directory, recursive = true);

    w := compiler_create_workspace("Target workspace");
    options := get_build_options(w);
    options.output_executable_name = "day1";
    copy_commonly_propagated_fields(get_build_options(), *options);

    #if #exists(JAILS_DIAGNOSTICS_BUILD) options.output_type = .NO_OUTPUT;

    options.output_path = tprint("%/", build_output_directory);

    set_build_options(options, w);

    add_build_file("day1.jai", w);

    copy_file("input.txt", tprint("%/input.txt", build_output_directory));
}
