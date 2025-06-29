package asm.integrations;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.http.*;
import java.net.URI;

/**
 * Wrapper gọi REST Gemini – trả về Decision.
 */
public class GeminiClient {
    private final String endpoint, apiKey;
    private final HttpClient http = HttpClient.newHttpClient();
    private final ObjectMapper mapper = new ObjectMapper();

    public GeminiClient(String endpoint, String apiKey) {
        this.endpoint = endpoint;
        this.apiKey   = apiKey;
    }

    public Decision decide(String promptJson) throws Exception {
        HttpRequest req = HttpRequest.newBuilder()
            .uri(URI.create(endpoint + "?key=" + apiKey))
            .header("Content-Type", "application/json")
            .POST(HttpRequest.BodyPublishers.ofString(promptJson))
            .build();

        HttpResponse<String> resp = http.send(req, HttpResponse.BodyHandlers.ofString());
        JsonNode root = mapper.readTree(resp.body());
        // Lấy text từ candidates[0].content.parts[0].text
        String text = root.path("candidates").get(0)
                          .path("content").path("parts").get(0)
                          .path("text").asText().trim().toLowerCase();
        String decision;
        if (text.contains("yes")) {
            decision = "APPROVED";
        } else if (text.contains("no")) {
            decision = "REJECTED";
        } else if (text.contains("consider") || text.contains("cân nhắc")) {
            decision = "CONSIDER";
        } else {
            decision = "CONSIDER"; // Mặc định nếu không rõ
        }
        return new Decision(decision, text);
    }

    public String rawResponse(String promptJson) throws Exception {
        HttpRequest req = HttpRequest.newBuilder()
            .uri(URI.create(endpoint + "?key=" + apiKey))
            .header("Content-Type", "application/json")
            .POST(HttpRequest.BodyPublishers.ofString(promptJson))
            .build();
        HttpResponse<String> resp = http.send(req, HttpResponse.BodyHandlers.ofString());
        return resp.body();
    }
}