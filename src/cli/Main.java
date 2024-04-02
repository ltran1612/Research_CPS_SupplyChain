package cli;
// the Java code for the HybridCPSASP 
import java.io.*;
import java.util.ArrayList;
import java.util.LinkedList;

import asklab.cpsf.CPSClingoReasoner; 

public class Main {
    private final static String SPARQL_FILE = "./dump.sparql";

    // preconditions, given the file paths to:
    // 1) ontologies.
    // 2) the asp files. 
    // 3) given the solver (default is Clingo)
    public static void main(String[] args) {
        Info info = new Info(args);
        ArrayList<File> ontoFiles = new ArrayList<File>(info.aspPaths.size());
        ArrayList<File> aspFiles = new ArrayList<File>(info.aspPaths.size()); 

        // get all string
        for (String path : info.ontoPaths) {
            File file = new File(path);
            if (!file.exists()) {
                throw new RuntimeException("Ontology file does not exist " + path);
            } // end if
            ontoFiles.add(file);
        } // end for
        
        // get all asp files
        for (String path : info.aspPaths) {
            File file = new File(path);
            if (!file.exists()) {
                throw new RuntimeException("asp files do not exist " + path);
            } // end if
            aspFiles.add(file);
        } // end for
    
        try {
            // query
            String res = CPSClingoReasoner.query(new File(SPARQL_FILE), ontoFiles, aspFiles, info.options);
            System.out.println(res);
            // print out the response
        } catch (IOException excp) {
            System.err.println(excp.getMessage());
        } // end catch
    } // end main
} // end Run class

// read file utilities
class Utils {
    // read file from a path
    static String readFile(String s) throws FileNotFoundException, IOException {
        BufferedReader br = new BufferedReader(new FileReader(s));
        String res = readFile(br);
        br.close();
        return (res);
    } // end readFile

    // read file from a File object
    static String readFile(File f) throws FileNotFoundException, IOException {
        BufferedReader br = new BufferedReader(new FileReader(f));
        String res = readFile(br);
        br.close();
        return (res);
    } // end readFile

    // read file from a bufferred reader
    static String readFile(BufferedReader br) throws IOException {
        String str = "", line;
        while ((line = br.readLine()) != null)
            str = str + line + "\n";
        return (str);
    } // end readFile
} // end class Utils

// a class that accepts the string arrays of arguments to get the required information needed
// to parse the data and get the results 
class Info {

    // the path the the directory containing all the important files
    // such as the ontology files and the ASP file.  
    public LinkedList<String> ontoPaths =  null;
    // the asp file to run 
    public LinkedList<String> aspPaths = null;
    // an integer denoting the solver to use
    
    public LinkedList<String> options = null;

    public Info(String[] args) {
        if (args.length == 0) {
            throw new RuntimeException("Not enough arguments");
        } // end if

        ontoPaths = new LinkedList<String>();
        aspPaths = new LinkedList<String>();
        options = new LinkedList<String>();

        boolean startOptions = false;
        for (String arg: args) {
            if (arg.endsWith(".owl")) {
                ontoPaths.add(arg);
            } else if (arg.endsWith(".lp")) {
                aspPaths.add(arg);
            } else if (!startOptions && arg.equals("--asp-options")) {
                startOptions = true;
            } else if (startOptions) {
                options.add(arg);
            } else {
                System.err.println("Invalid arguments.");
                System.exit(1);
            } // end else
        } // end for 
    } // end InfoConstructor
} // end Info