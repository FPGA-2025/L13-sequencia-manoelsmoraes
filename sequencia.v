module Sequencia (
    input wire clk,
    input wire rst_n,

    input wire setar_palavra,   // Sinal para armazenar nova palavra
    input wire [7:0] palavra,   // Palavra a ser buscada

    input wire start,           // Indica o início da entrada serial
    input wire bit_in,          // Bit de entrada serial

    output reg encontrado       // Ativado quando a sequência é encontrada
);

    reg [7:0] palavra_desejada;    // Registrador para armazenar a palavra a ser procurada
    reg [7:0] buffer_deslocamento; // Registrador de deslocamento para armazenar os bits recebidos
    reg recebendo_bits;            // Sinal para indicar que estamos recebendo os bits

    // Lógica de controle e atualização dos sinais
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset síncrono: limpa todos os registros e sinais
            palavra_desejada <= 8'b0;
            buffer_deslocamento <= 8'b0;
            encontrado <= 1'b0;
            recebendo_bits <= 1'b0;
        end else begin
            if (setar_palavra) begin
                // Se 'setar_palavra' for ativado, carrega a nova palavra e limpa os buffers
                palavra_desejada <= palavra;
                buffer_deslocamento <= 8'b0;
                encontrado <= 1'b0;
                recebendo_bits <= 1'b0;  // Reseta o sinal de recebendo
            end else if (start) begin
                // Se 'start' for ativado, começa a recepção de bits
                recebendo_bits <= 1'b1;
                buffer_deslocamento <= 8'b0;  // Limpa o buffer no início
                encontrado <= 1'b0;  // Garante que a busca recomeça
            end else if (recebendo_bits && !encontrado) begin
                // Enquanto estamos recebendo e não encontramos a palavra
                buffer_deslocamento <= {buffer_deslocamento[6:0], bit_in};  // Desloca os bits
                if (buffer_deslocamento == palavra_desejada) begin
                    encontrado <= 1'b1;  // Palavra encontrada
                end
            end
            // fim manter registro -> seq1 erro log.
        end
    end

endmodule
