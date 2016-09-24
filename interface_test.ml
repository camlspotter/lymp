

class pymodule module_name =
	object
		val _name = module_name

	method call = py_call _name

(* pyroot can be specified to change the location from which 
   the python client will be launched, effectively allowing to 
   use python modules from anywhere on the filesystem, like ../../py_utils *)
let pyroot = "."
let fetch = pymodule "fetch"

type pyobj =
	Pystr of string
	| Pyint of int
	| Pylist of pyobj list
	| Pynone
	| Pynamedarg of (str * pyobj)

let rec print_pyobj = function
	| Pystr str -> print_endline str
	| Pyint i -> print_int i ; print_endline ""
	| Pynone -> print_endline "None"
	| Pylist lst -> List.iter print_pyobj lst

let py_call modul name args =
	print_endline modul ;
	print_endline name ;
	List.iter print_pyobj args

let compute = py_call "my_module" "compute"

let get_url = py_call "my_module" "get_url"

let () =
	compute [Pystr "salut"; Pyint 3; Pynone] ;
	py_call "my_module" "get_url" [Pystr "https://google.fr"] ;
	get_url [Pystr "https://google.fr"] ;
	let page_content = fetch.call "get_url" [Pystr "https://google.fr"] in
		match page_content with
		| Pystr str -> print_endline str
		| _ -> raise "error"