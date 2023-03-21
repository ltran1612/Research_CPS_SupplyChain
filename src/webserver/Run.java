package webserver;

import java.nio.file.*;
import java.io.*;
import java.util.*;
import asklab.cpsf.CPSReasoner;

public class Run {
    static String baseDir = "./asklab/querypicker/QUERIES//BASE";
    static String exDir = "./asklab/querypicker/QUERIES/EX4-sr-elevator";
    static String aspFile = "FULL-SR-ER-01-ELE-01-00.txt";
    static String sparqlFile = "asklab/querypicker/dump.sparql";
    static int solver = 3;

    public static void main(String[] args) {
        String tmpDir = "./tmpDir";

        try {
            deleteDirectoryStream(new File(tmpDir).toPath());
        } catch (Exception x) {
        }

        if (!new File(tmpDir).mkdir()) {
            System.err.println("unable to create the directory " + tmpDir);
            System.exit(-1);
        }

        copyOWL(baseDir, tmpDir);
        copyOWL(exDir, tmpDir);
        String f = exDir + "/" + aspFile;
        Path source = new File(f).toPath();
        Path newdir = new File(tmpDir).toPath();
        try {
            Files.copy(source, newdir.resolve(source.getFileName()));
        } catch (FileAlreadyExistsException x) {
        } catch (IOException x) {
            System.err.println("Unable to copy " + f + " to " + tmpDir);
        } // end catch

        try {
            String sparqlQ = Utils.readFile(sparqlFile);
            System.out.println(sparqlFile + " loaded.");
    
            String aspQ = Utils.readFile(tmpDir + "/" + aspFile);
    
            String res = CPSReasoner.query(sparqlQ, aspQ, tmpDir, solver);
    
            System.out.println(res);
        } catch (IOException excp) {
            System.err.println(excp.getMessage());
        } // end catch
       
    } // end main

    static void deleteDirectoryStream(Path path) throws IOException {
		Files.walk(path).sorted(Comparator.reverseOrder()).map(Path::toFile).forEach(File::delete);
	} // end deleteDirectoryStream

    static void copyOWL(String dir, String tmpDir) {
		class OWLFilter implements FilenameFilter {
			public boolean accept(File dir, String f) {
				return (f.endsWith(".owl"));
			}
		}

		ArrayList<File> filesToCopy = new ArrayList<File>();
		File sourceDirectory = new File(dir);
		String[] toCopy = sourceDirectory.list(new OWLFilter());
		for (String file : toCopy) {
			try {
				Path source = new File(dir + "/" + file).toPath();
				Path newdir = new File(tmpDir).toPath();
				Files.copy(source, newdir.resolve(source.getFileName()));
			} catch (FileAlreadyExistsException x) {
			} catch (IOException x) {
				System.err.println("Unable to copy " + file + " to " + tmpDir);
			}
		}
	}
} // end Run class

class Utils {
    static String readFile(String s) throws FileNotFoundException, IOException {
        BufferedReader br = new BufferedReader(new FileReader(s));
        String res = readFile(br);
        br.close();
        return (res);
    }

    static String readFile(File f) throws FileNotFoundException, IOException {
        BufferedReader br = new BufferedReader(new FileReader(f));
        String res = readFile(br);
        br.close();
        return (res);
    }

    static String readFile(BufferedReader br) throws IOException {
        String str = "", line;
        while ((line = br.readLine()) != null)
            str = str + line + "\n";
        return (str);
    }
}