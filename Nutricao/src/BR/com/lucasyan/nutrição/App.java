package BR.com.lucasyan.nutrição;
import BR.com.lucasyan.nutrição.Alimento;

import java.util.Scanner;


public class App {

    public static void main(String[] args) throws Exception {


        Scanner scanner = new Scanner(System.in);
        
        System.out.println("Escolha uma proteína (Carne, Frango, Peixe): ");
        String proteina = scanner.nextLine();
        System.out.println("Escolha um carboidrato (Arroz, Batata, Macarrão): ");
        String carboidrato = scanner.nextLine();                
        System.out.println("Escolha um legume (Brócolis, Cenoura, Couve-flor): ");
        String legume = scanner.nextLine();

        Alimento alimentoProteina = new Alimento(proteina, 200); // Exemplo de calorias
        Alimento alimentoCarboidrato = new Alimento(carboidrato, 150); // Exemplo de calorias
        Alimento alimentoLegume = new Alimento(legume, 50); // Exemplo de calorias


        int caloriasTotais = alimentoProteina.getCalorias() + alimentoCarboidrato.getCalorias() + alimentoLegume.getCalorias();
        System.err.println("Refeição escolhida: " + alimentoProteina.getNome() + ", " + alimentoCarboidrato.getNome() + ", " + alimentoLegume.getNome());
        System.err.println("Calorias totais da refeição: " + caloriasTotais);
        if (caloriasTotais > 500) {
            System.out.println("A refeição é rica em calorias.");
        } else {
            System.out.println("A refeição é leve em calorias."); 
        }
        scanner.close();
    }
}
