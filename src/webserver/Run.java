package webserver;

import java.io.*;

import asklab.cpsf.CPSReasoner;

public class Run {
    private final static String SPARQL_FILE = "asklab/querypicker/dump.sparql";

    // given a directory containing the ontologies, the asp file. 
    // given the asp file path in the temporary directory
    // given the solver
    public static void main(String[] args) {
        Info info = new Info(args);
        System.err.println("dir path: " + info.dirPath);
        System.err.println("asp: " + info.aspFileName);
        
        try {
            String sparqlQ = Utils.readFile(SPARQL_FILE);
            // read the asp file
            String aspQ = Utils.readFile(info.dirPath + "/" + info.aspFileName);
            // query
            String res = CPSReasoner.query(sparqlQ, aspQ, info.dirPath, info.solver);
            // print out the response
            System.out.println(res);
        } catch (IOException excp) {
            System.err.println(excp.getMessage());
        } // end catch
       
    } // end main

} // end Run class

// read file
class Utils {
    static String readFile(String s) throws FileNotFoundException, IOException {
        BufferedReader br = new BufferedReader(new FileReader(s));
        String res = readFile(br);
        br.close();
        return (res);
    } // end readFile

    static String readFile(File f) throws FileNotFoundException, IOException {
        BufferedReader br = new BufferedReader(new FileReader(f));
        String res = readFile(br);
        br.close();
        return (res);
    } // end readFile

    static String readFile(BufferedReader br) throws IOException {
        String str = "", line;
        while ((line = br.readLine()) != null)
            str = str + line + "\n";
        return (str);
    } // end readFile
} // end class Utils

class Info {
    public String dirPath;
    public String aspFileName;
    public int solver;

    public Info(String[] args) {
        if (args.length < 3) {
            throw new RuntimeException("Not enough arguments");
        } // end if
        dirPath = args[0];
        aspFileName = args[1];
        solver = Integer.parseInt(args[2]);
    } // end InfoConstructor
} // end Info