package BR.com.lucasyan.nutrição;

public class Alimento {
    private String nome;
    private int calorias;

    public Alimento(String nome, int calorias) {
        this.nome = nome;
        this.calorias = calorias;
    }

    public String getNome() {
        return nome;
    }

    public int getCalorias() {
        return calorias;
    }
    
}
