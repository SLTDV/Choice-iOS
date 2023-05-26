import Foundation

public enum CalculateToVoteCountPercentage {
    public static func calculateToVoteCountPercentage(firstVotingCount: Double, secondVotingCount: Double) -> (String, String, Int, Int) {
        let sum = firstVotingCount + secondVotingCount
        print("fasdf = \(firstVotingCount / sum)")
        let firstP = firstVotingCount / sum * 100.0
        let secondP = secondVotingCount / sum * 100.0
        
        print(firstVotingCount / sum * 100.0)
        print("string = \(firstVotingCount / sum * 100.0)")
        
        let firstStr = String(firstP)
        let secondStr = String(secondP)
        
        return (firstStr, secondStr, Int(firstVotingCount), Int(secondVotingCount))
    }
}
