package asklab.cpsf;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Vector;
import java.util.stream.Collectors;

public class CPSClingoReasoner {
	// put the path of all ontologies in a single string with space in between them 
	private static ArrayList<String> ontologyFileList(List<File> ontologyFileList, String prefix) throws IOException, Exception {
		// get a list  of files in the ontology folder
		Object[] ontologyFiles = (Object[]) ontologyFileList.toArray();
		// sort the list
		Arrays.sort(ontologyFiles);

		ArrayList<String> list = new ArrayList<String>(ontologyFiles.length);
		// for each file in the folder
		for (Object object : ontologyFiles) {
			File f = (File) object;
			String filePath = f.toString();

			// check if the file is an ontology file
			if (!filePath.endsWith(".owl")) {
				throw new Exception("Only accepts .owl files for ontologies.");
			} // end if

			// if there is space, error
			if (filePath.indexOf(" ") >= 0) {
				throw (new IOException("No spaces allowed in filenames. Aborting. Offending filename: " + filePath));
			} // end if
				
			// if windows OS, change the file path 
			/*
				* For jena to work properly under Windows with X:/... paths, we need to prefix
				* the path with "/". Since this does not affect pellet, we do it regardless of
				* reasoner.
			*/
			if (isWindows()) { 					
				if (filePath.indexOf(":") >= 0)
					filePath = "/" + filePath;
			} // end if
				
			// append it to the final result with a space
			list.add(prefix + filePath);
		} // end for file

		return (list);
	} // end ontologyFileList
	
	public static ReturnValue ontologyToASP(File sparqlQueryFile, List<File> ontologyFiles) throws IOException, Exception {
		// query the ontologies with the SPARQL query.
		List<String> arguments = ontologyFileList(ontologyFiles, "--data=");
		arguments = arguments.stream().map(
			(String argument) -> argument.replace("\\", "/").trim()
		).collect(Collectors.toList());
		String[] cmd = jenaCmd(sparqlQueryFile.getAbsolutePath(), arguments);
		ReturnValue returnValue = runCmdRaw(cmd);
		return returnValue;
	} // end ontologyToASP

	public static ReturnValue runClingo(List<File> aspFiles, List<String> clingoOptions) throws Exception {
		String[] arguments =  new String[aspFiles.size() + clingoOptions.size() + 1];
		arguments[0] = "clingo";
		int index = 1;
		
		for (File file : aspFiles) {
			arguments[index] = file.toPath().toString();
			index++;
		} // end for 
		for (String option : clingoOptions) {
			arguments[index] = option; 
			index++;
		} // end for 
		ReturnValue out = runCmdRaw(arguments);
		return out;
	} // end asp

	// query the CPS + Ontology
	public static ReturnValue query(File sparqlQueryFile, List<File> ontologyFiles, List<File> aspFiles, List<String> clingoOptions) throws Exception {
		// name of the temporary file for sparql
		Path tmpFile = Files.createTempFile("", ".lp");
		tmpFile.toFile().deleteOnExit();
		ReturnValue res = null;
		try {
// STEP 1			
			if (ontologyFiles.size() != 0) {
				res = ontologyToASP(sparqlQueryFile, ontologyFiles);
				if (res.getReturnCode() != 0)
					return res;
				//  get the result
				Vector<String> lines = res.getStdoutVector();
				/* map jena's output to ASP facts */
				String aspProg = jenaToASP(lines);
				writeToFile(tmpFile.toFile().getAbsolutePath(), aspProg);
				res = new ReturnValue(res.getReturnCode(), aspProg);
			} // end if
			// write this to a temp file
// STEP 2
			// write the completed ASP program to the temp file
			if (aspFiles.size() != 0) {
				aspFiles.add(tmpFile.toFile());
				res = runClingo(aspFiles, clingoOptions);
			}  // end if
			return res;
		} catch (Exception x) {
			throw x;
		} finally {
			if (!tmpFile.toFile().delete())
				tmpFile.toFile().deleteOnExit();
		}
	} // end query

	// get the package path that is stored in this same module/package	
	static void copyResourceFromClassFolderToFile(String inFilePath, Path outFilePath) {
		if (CPSClingoReasoner.class.getResource(inFilePath) == null) {
			throw new RuntimeException("Path does not exist");
		} // end if
		try (InputStream in = CPSClingoReasoner.class.getResourceAsStream(inFilePath)) {
			Files.copy(in, outFilePath,StandardCopyOption.REPLACE_EXISTING);
		} catch(IOException exception) {
			throw new RuntimeException(exception.getMessage());
		}
	} // get the path to a package

	// write a string to a file
	static void writeToFile(String file, String str) throws IOException {
		FileWriter out = new FileWriter(file);
		out.write(str);
		out.close();
	} // end writeToFile

	// convert jena output to ASP
	static String jenaToASP(Vector<String> in) {
		String aspProg = "";

		for (int i = 3; /* first 4 lines are headers */
				i < in.size() - 1; /* last line is footer */
				i++) {
			String line = in.elementAt(i);
			/* first "|" mapped to 'input("' */
			line = line.replaceFirst("^\\| *", "input(\"");
			/* last "|" mapped to '").' */
			line = line.replaceFirst(" *\\|$", "\").");
			/* intermediate "|" mapped to '","' */
			line = line.replaceAll(" *\\| *", "\",\"");
			/* 'cvast:' prefix removed */
			line = line.replaceAll("cvast:", "");
			/* 'myprefix:' prefix removed */
			line = line.replaceAll("myprefix:", "");
			/*
			 * Replace '""' by '"'. Double quotes are generated by the above replacements if
			 * jena returned a string. Jena returns strings enclosed in double quotes.
			 */
			line = line.replaceAll("\"\"", "\"");
			/* ^^xsd:int" removed */
			line = line.replaceAll("\\^\\^xsd:int\"", "");
			aspProg += line + "\n";
		} // end for i
		return (aspProg);
	} // end jenaToASP

	// run a command with no data
	static ReturnValue runCmdRaw(String[] cmd) throws IOException {
		return (runCmdRaw(cmd, null));
	} // end runCmdRaw

	public static class ReturnValue {
		private int status;
		private Vector<String> res;
		private Vector<String> error;
		private Vector<String> combined;
		private String output = null;

		private ReturnValue(int _status, Vector<String> _res, Vector<String> _error, Vector<String> _combined) {
			status = _status;
			res = _res;
			error = _error;
			combined = _combined;
		} // return Value

		private ReturnValue(int _status, String _output) {
			status = _status;
			output = _output;
		} // return Value

		public int getReturnCode() {return status;}
		public String getStdout() {return String.join("\n", res);}
		private Vector<String> getStdoutVector() {return new Vector<String>(res);}
		public String getStderr() {return String.join("\n", error);}
		public String getCombinedOutput() {
			if (output != null)
				return output;
			return String.join("\n", combined);
		} // end getCombinedOutput
	};
	
	// run a command with data
	private static ReturnValue runCmdRaw(String[] cmdParts, String inData) throws IOException {
		Runtime r = Runtime.getRuntime();
		// execute the command
		Process p = r.exec(cmdParts);

		Thread outputFiller = null;
		if (inData != null) {
			outputFiller = new Thread(new StreamFiller(p.getOutputStream(), inData));
			outputFiller.start();
			// PrintWriter out=new PrintWriter(p.getOutputStream());
			// out.print(inData);
			// out.close();
		} // end if

		/* retrieve the output */
		Vector<String> res = new Vector<String>();
		Vector<String> combined = new Vector<String>();
		Vector<String> error = new Vector<String>();
		try {
			ReadStream s1, s2, s3, s4;
			s1 = new ReadStream("stdout", p.getInputStream(), res, combined, false);
			s2 = new ReadStream("stderr", p.getErrorStream(), error, combined, false);
			//
			s1.start();
			s2.start();
			//
			p.waitFor();
			//
			s1.waitFor();
			s2.waitFor();
			if (outputFiller != null)
				outputFiller.join();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (p != null)
				p.destroy();
		} // end finally

		return new ReturnValue(p.exitValue(), res, error, combined);
	} // end runCmdRaw

	// run a command with no data
	static String runCmd(String[] cmd) throws IOException {
		return (runCmd(cmd, null));
	}  // end runCmd

	// run a command with data
	static String runCmd(String[] cmd, String inData) throws IOException {
		String res;

		res = "";
		for (String line : runCmdRaw(cmd, inData).res)
			res = res + line + "\n";

		return (res);
	} // end runCmd

	// get a command to run a jena on the ontology files with a query 
	static String[] jenaCmd(String queryFile, List<String> ontologies) throws IOException {
		ArrayList<String> cmdParts = new ArrayList<String>();
		// add the command to run sparql 
		cmdParts.add("sparql");

		// pass in the query file in the cmd
		cmdParts.add("--file=" + queryFile.trim()); 

		// pass in the ontologies files to the cmd
		cmdParts.addAll(ontologies); 

		// set the result of jena
		cmdParts.add("--results=text");

		return cmdParts.toArray(new String[0]);
	} // end jenaCmd

	// get a command to run clingo on a particular asp file
	static String clingoCmd(String arguments) {
		String cmd = "";

		// cmd="./clingo-4.4.0/";
		// get the path to clingo folder
		// cmd = pkgPath("clingo-4.4.0/");

		// choose the right executable
		if (isWindows())
			cmd += "clingo.exe";
		else if (isMacOSX())
			cmd += "clingo-macosx";
		else
			cmd += "clingo-linux-x86";
		
		// pass in the asp file to run on
		cmd += " " + arguments;

		return (cmd);
	} // end clingoCmd

	// Windows OS?
	static boolean isWindows() {
		String OS = System.getProperty("os.name");
		//System.out.println("os=" + OS);
		return (OS.startsWith("Windows"));
	} // end isWindows

	// MacOS ?
	static boolean isMacOSX() {
		String OS = System.getProperty("os.name");
		return (OS.startsWith("Mac"));
	} // end isMacOSX

	// a Runnable 
	static class ReadStream implements Runnable {
		String name;
		InputStream is;
		Vector<String> v;
		Vector<String> pipe;
		boolean discard;
		Thread thread;
		static Object mutex = new Object();

		public ReadStream(String name, InputStream is, Vector<String> v, boolean discard) {
			this.name = name;
			this.is = is;
			this.v = v;
			this.discard = discard;
		} // end ReadStream

		public ReadStream(String name, InputStream is, Vector<String> v, Vector<String> _pipe, boolean discard) {
			this.name = name;
			this.is = is;
			this.v = v;
			this.discard = discard;
			this.pipe = _pipe;
		} // end ReadStream

		public void start() {
			thread = new Thread(this);
			thread.start();
		} // end start

		public void waitFor() throws InterruptedException {
			thread.join();
		} // end waitFor

		public void run() {
			try {
				InputStreamReader isr = new InputStreamReader(is);
				BufferedReader br = new BufferedReader(isr);
				while (true) {
					String s = br.readLine();
					if (s == null)
						break;

					if (discard);
						//System.out.println("[" + name + "] " + s);
					else {
						synchronized(mutex) {
							v.addElement(s);
						} // end syncrhonized

						if (pipe != null) {
							synchronized(mutex) {
								pipe.addElement(s);
							} // end syncrhonized
						} // end if
					} // end while 
				} // end while
				is.close();
			} catch (Exception ex) {
				System.err.println("Problem reading stream " + name + "... :" + ex);
				ex.printStackTrace();
			} // end catch
		} // end Run
	} // end class ReadStream

	static class StreamFiller implements Runnable {
		private final OutputStream os;
		private final String inData;

		StreamFiller(OutputStream os, String inData) {
			this.os = os;
			this.inData = inData;
		} // end StreamFiller

		public void run() {
			PrintWriter out = new PrintWriter(os);
			out.print(inData);
			out.close();
		} // end run
	} // end class StreamFiller
} // end class CPSReasoner 
