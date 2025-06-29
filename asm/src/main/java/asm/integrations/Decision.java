package asm.integrations;

/**
 * DTO cho kết quả từ Gemini.
 */
public class Decision {
    private final String decision;
    private final String comment;

    public Decision(String decision, String comment) {
        this.decision = decision;
        this.comment  = comment;
    }

    public String getDecision() { return decision; }
    public String getComment()  { return comment;  }
}