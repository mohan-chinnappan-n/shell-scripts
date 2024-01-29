public class Utils {

    // Creating Records
    public static void createRecord(SObject obj) {
        insert obj;
    }

    // Inserting Records
    public static void insertRecord(SObject obj) {
        insert obj;
    }

    // Deleting Records
    public static void deleteRecord(SObject obj) {
        delete obj;
    }

    // Updating Records
    public static void updateRecord(SObject obj) {
        update obj;
    }

    // Writing Apex Service
    @RestResource(urlMapping='/exampleService/*')
    global with sharing class ExampleRestService {

        @HttpGet
        global static String doGet() {
            return 'Hello from REST service!';
        }

        @HttpPost
        global static String doPost(String name) {
            return 'Hello, ' + name + '!';
        }
    }

    global with sharing class ExampleSoapService {
        webservice static String greet(String name) {
            return 'Hello, ' + name + '!';
        }
    }

    public class UuidException extends Exception {
        public UuidException(String message) {
            super(message);
        }
    }
}
