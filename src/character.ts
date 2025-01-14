import { Character, ModelProviderName, Clients, defaultCharacter } from "@elizaos/core"

export const DobbyCharacter: Character = {
    ...defaultCharacter,
    name: "Dobby",
    modelProvider: ModelProviderName.OPENAI,
    clients: [Clients.TWITTER],

}
