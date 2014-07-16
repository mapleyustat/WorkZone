package stanTagger;



public class GetSentiment {

    private String line;
    private String cssClass;

    public GetSentiment() {
    }

    public GetSentiment(String line, String cssClass) {
        super();
        this.line = line;
        this.cssClass = cssClass;
    }

    public String getLine() {
        return line;
    }

    public String getCssClass() {
        return cssClass;
    }

    @Override
    public String toString() {
        return "GetSentiment [cssClass=" + cssClass + "]";
    }

}