import Testing

@testable import PureRank

@Suite struct TeamFreeForAllTests {
  @Test func playerUpdates() async throws {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 30, deviation: 4),
      Player(id: "Bob", mean: 28, deviation: 6),
      Player(id: "Carol", mean: 26, deviation: 5),
      Player(id: "Dave", mean: 24, deviation: 8),
      Player(id: "Eve", mean: 22, deviation: 7),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 32, deviation: 3),
      Player(id: "Grace", mean: 29, deviation: 5),
      Player(id: "Heidi", mean: 27, deviation: 6),
      Player(id: "Ivan", mean: 25, deviation: 7),
      Player(id: "Judy", mean: 23, deviation: 8),
    ])

    let teamC = Team(players: [
      Player(id: "Kevin", mean: 28, deviation: 4),
      Player(id: "Laura", mean: 26, deviation: 5),
      Player(id: "Michael", mean: 24, deviation: 6),
      Player(id: "Natalie", mean: 22, deviation: 7),
      Player(id: "Olivia", mean: 20, deviation: 8),
    ])

    let teamD = Team(players: [
      Player(id: "Peter", mean: 26, deviation: 5),
      Player(id: "Quinn", mean: 24, deviation: 6),
      Player(id: "Rachel", mean: 22, deviation: 7),
      Player(id: "Steve", mean: 20, deviation: 8),
      Player(id: "Tina", mean: 18, deviation: 9),
    ])

    let match = TeamFreeForAll(teams: [teamA, teamB, teamC, teamD])
    let result = UpdateSkill().teamFreeForAll(match)

    func expectPlayer(id: String, mean: Double, deviation: Double) {
      #expect(
        result.hasPlayer(
          id: id,
          mean: mean, meanEpsilon: 0.01,
          deviation: deviation, deviationEpsilon: 0.01,
        )
      )
    }

    expectPlayer(id: "Alice", mean: 30.66, deviation: 3.96)
    expectPlayer(id: "Bob", mean: 29.49, deviation: 5.86)
    expectPlayer(id: "Carol", mean: 27.03, deviation: 4.92)
    expectPlayer(id: "Dave", mean: 26.65, deviation: 7.67)
    expectPlayer(id: "Eve", mean: 24.03, deviation: 6.78)

    expectPlayer(id: "Frank", mean: 31.85, deviation: 2.97)
    expectPlayer(id: "Grace", mean: 28.57, deviation: 4.86)
    expectPlayer(id: "Heidi", mean: 26.37, deviation: 5.75)
    expectPlayer(id: "Ivan", mean: 24.12, deviation: 6.62)
    expectPlayer(id: "Judy", mean: 21.82, deviation: 7.43)

    expectPlayer(id: "Kevin", mean: 28.02, deviation: 3.94)
    expectPlayer(id: "Laura", mean: 26.03, deviation: 4.88)
    expectPlayer(id: "Michael", mean: 24.03, deviation: 5.79)
    expectPlayer(id: "Natalie", mean: 22.03, deviation: 6.66)
    expectPlayer(id: "Olivia", mean: 20.01, deviation: 7.51)

    expectPlayer(id: "Peter", mean: 25.32, deviation: 4.94)
    expectPlayer(id: "Quinn", mean: 23.03, deviation: 5.89)
    expectPlayer(id: "Rachel", mean: 20.67, deviation: 6.83)
    expectPlayer(id: "Steve", mean: 18.27, deviation: 7.75)
    expectPlayer(id: "Tina", mean: 15.81, deviation: 8.64)
  }

  @Test func uncertaintyDecrease() throws {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 30, deviation: 4),
      Player(id: "Bob", mean: 28, deviation: 6),
      Player(id: "Carol", mean: 26, deviation: 5),
      Player(id: "Dave", mean: 24, deviation: 8),
      Player(id: "Eve", mean: 22, deviation: 7),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 32, deviation: 3),
      Player(id: "Grace", mean: 29, deviation: 5),
      Player(id: "Heidi", mean: 27, deviation: 6),
      Player(id: "Ivan", mean: 25, deviation: 7),
      Player(id: "Judy", mean: 23, deviation: 8),
    ])

    let teamC = Team(players: [
      Player(id: "Kevin", mean: 28, deviation: 4),
      Player(id: "Laura", mean: 26, deviation: 5),
      Player(id: "Michael", mean: 24, deviation: 6),
      Player(id: "Natalie", mean: 22, deviation: 7),
      Player(id: "Olivia", mean: 20, deviation: 8),
    ])

    let teamD = Team(players: [
      Player(id: "Peter", mean: 26, deviation: 5),
      Player(id: "Quinn", mean: 24, deviation: 6),
      Player(id: "Rachel", mean: 22, deviation: 7),
      Player(id: "Steve", mean: 20, deviation: 8),
      Player(id: "Tina", mean: 18, deviation: 9),
    ])

    let match = TeamFreeForAll(teams: [teamA, teamB, teamC, teamD])
    let result = UpdateSkill().teamFreeForAll(match)

    func expectDeviationDecrease(id: String) throws {
      let before = try #require(match.findPlayer(id: id))
      let after = try #require(result.findPlayer(id: id))
      #expect(after.deviation < before.deviation)
    }

    for id in [
      "Alice", "Bob", "Carol", "Dave", "Eve",
      "Frank", "Grace", "Heidi", "Ivan", "Judy",
      "Kevin", "Laura", "Michael", "Natalie", "Olivia",
      "Peter", "Quinn", "Rachel", "Steve", "Tina",
    ] {
      try expectDeviationDecrease(id: id)
    }
  }

  @Test func teamFreeForAllWithDrawsPlayerUpdates() async throws {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 30, deviation: 4),
      Player(id: "Bob", mean: 28, deviation: 6),
      Player(id: "Carol", mean: 26, deviation: 5),
      Player(id: "Dave", mean: 24, deviation: 8),
      Player(id: "Eve", mean: 22, deviation: 7),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 32, deviation: 3),
      Player(id: "Grace", mean: 29, deviation: 5),
      Player(id: "Heidi", mean: 27, deviation: 6),
      Player(id: "Ivan", mean: 25, deviation: 7),
      Player(id: "Judy", mean: 23, deviation: 8),
    ])

    let teamC = Team(players: [
      Player(id: "Kevin", mean: 28, deviation: 4),
      Player(id: "Laura", mean: 26, deviation: 5),
      Player(id: "Michael", mean: 24, deviation: 6),
      Player(id: "Natalie", mean: 22, deviation: 7),
      Player(id: "Olivia", mean: 20, deviation: 8),
    ])

    let teamD = Team(players: [
      Player(id: "Peter", mean: 26, deviation: 5),
      Player(id: "Quinn", mean: 24, deviation: 6),
      Player(id: "Rachel", mean: 22, deviation: 7),
      Player(id: "Steve", mean: 20, deviation: 8),
      Player(id: "Tina", mean: 18, deviation: 9),
    ])

    let match = TeamFreeForAllWithDraws(teams: [[teamA], [teamB, teamC], [teamD]])
    let result = UpdateSkill().teamFreeForAllWithDraws(match)

    func expectPlayer(id: String, mean: Double, deviation: Double) {
      #expect(
        result.hasPlayer(
          id: id,
          mean: mean, meanEpsilon: 0.01,
          deviation: deviation, deviationEpsilon: 0.01,
        )
      )
    }

    expectPlayer(id: "Alice", mean: 30.66, deviation: 3.96)
    expectPlayer(id: "Bob", mean: 29.49, deviation: 5.86)
    expectPlayer(id: "Carol", mean: 27.03, deviation: 4.92)
    expectPlayer(id: "Dave", mean: 26.65, deviation: 7.67)
    expectPlayer(id: "Eve", mean: 24.03, deviation: 6.78)

    expectPlayer(id: "Frank", mean: 31.51, deviation: 2.96)
    expectPlayer(id: "Grace", mean: 27.65, deviation: 4.83)
    expectPlayer(id: "Heidi", mean: 25.06, deviation: 5.70)
    expectPlayer(id: "Ivan", mean: 22.37, deviation: 6.53)
    expectPlayer(id: "Judy", mean: 19.58, deviation: 7.31)

    expectPlayer(id: "Kevin", mean: 28.53, deviation: 3.92)
    expectPlayer(id: "Laura", mean: 26.82, deviation: 4.85)
    expectPlayer(id: "Michael", mean: 25.17, deviation: 5.75)
    expectPlayer(id: "Natalie", mean: 23.57, deviation: 6.60)
    expectPlayer(id: "Olivia", mean: 22.02, deviation: 7.40)

    expectPlayer(id: "Peter", mean: 25.49, deviation: 4.95)
    expectPlayer(id: "Quinn", mean: 23.26, deviation: 5.91)
    expectPlayer(id: "Rachel", mean: 20.99, deviation: 6.85)
    expectPlayer(id: "Steve", mean: 18.69, deviation: 7.78)
    expectPlayer(id: "Tina", mean: 16.34, deviation: 8.69)
  }

  @Test func teamFreeForAllWithDrawsUncertaintyDecrease() throws {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 30, deviation: 4),
      Player(id: "Bob", mean: 28, deviation: 6),
      Player(id: "Carol", mean: 26, deviation: 5),
      Player(id: "Dave", mean: 24, deviation: 8),
      Player(id: "Eve", mean: 22, deviation: 7),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 32, deviation: 3),
      Player(id: "Grace", mean: 29, deviation: 5),
      Player(id: "Heidi", mean: 27, deviation: 6),
      Player(id: "Ivan", mean: 25, deviation: 7),
      Player(id: "Judy", mean: 23, deviation: 8),
    ])

    let teamC = Team(players: [
      Player(id: "Kevin", mean: 28, deviation: 4),
      Player(id: "Laura", mean: 26, deviation: 5),
      Player(id: "Michael", mean: 24, deviation: 6),
      Player(id: "Natalie", mean: 22, deviation: 7),
      Player(id: "Olivia", mean: 20, deviation: 8),
    ])

    let teamD = Team(players: [
      Player(id: "Peter", mean: 26, deviation: 5),
      Player(id: "Quinn", mean: 24, deviation: 6),
      Player(id: "Rachel", mean: 22, deviation: 7),
      Player(id: "Steve", mean: 20, deviation: 8),
      Player(id: "Tina", mean: 18, deviation: 9),
    ])

    let match = TeamFreeForAllWithDraws(teams: [[teamA], [teamB, teamC], [teamD]])
    let result = UpdateSkill().teamFreeForAllWithDraws(match)

    func expectDeviationDecrease(id: String) throws {
      let before = try #require(match.findPlayer(id: id))
      let after = try #require(result.findPlayer(id: id))
      #expect(after.deviation < before.deviation)
    }

    for id in [
      "Alice", "Bob", "Carol", "Dave", "Eve",
      "Frank", "Grace", "Heidi", "Ivan", "Judy",
      "Kevin", "Laura", "Michael", "Natalie", "Olivia",
      "Peter", "Quinn", "Rachel", "Steve", "Tina",
    ] {
      try expectDeviationDecrease(id: id)
    }
  }

  @Test func winVsDrawSkillChange() async throws {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 30, deviation: 4),
      Player(id: "Bob", mean: 28, deviation: 6),
      Player(id: "Carol", mean: 26, deviation: 5),
      Player(id: "Dave", mean: 24, deviation: 8),
      Player(id: "Eve", mean: 22, deviation: 7),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 32, deviation: 3),
      Player(id: "Grace", mean: 29, deviation: 5),
      Player(id: "Heidi", mean: 27, deviation: 6),
      Player(id: "Ivan", mean: 25, deviation: 7),
      Player(id: "Judy", mean: 23, deviation: 8),
    ])

    let teamC = Team(players: [
      Player(id: "Kevin", mean: 28, deviation: 4),
      Player(id: "Laura", mean: 26, deviation: 5),
      Player(id: "Michael", mean: 24, deviation: 6),
      Player(id: "Natalie", mean: 22, deviation: 7),
      Player(id: "Olivia", mean: 20, deviation: 8),
    ])

    let teamD = Team(players: [
      Player(id: "Peter", mean: 26, deviation: 5),
      Player(id: "Quinn", mean: 24, deviation: 6),
      Player(id: "Rachel", mean: 22, deviation: 7),
      Player(id: "Steve", mean: 20, deviation: 8),
      Player(id: "Tina", mean: 18, deviation: 9),
    ])

    let decisiveMatch = TeamFreeForAllWithDraws(teams: [[teamA], [teamB], [teamC], [teamD]])
    let decisiveResult = UpdateSkill().teamFreeForAllWithDraws(decisiveMatch)
    let drawMatch = TeamFreeForAllWithDraws(teams: [[teamA], [teamB, teamC], [teamD]])
    let drawResult = UpdateSkill().teamFreeForAllWithDraws(drawMatch)

    let decisiveTeamA = decisiveResult.teams[0][0]
    let drawPlayerA = drawResult.teams[0][0]

    let decisiveChangeA = decisiveTeamA.mean - teamA.mean
    let drawChangeA = drawPlayerA.mean - teamA.mean

    #expect(decisiveChangeA > 0)
    #expect(drawChangeA > 0)
    #expect(decisiveChangeA == drawChangeA)

    let decisiveTeamB = decisiveResult.teams[1][0]
    let drawTeamB = drawResult.teams[1][0]

    let decisiveChangeB = decisiveTeamB.mean - teamB.mean
    let drawChangeB = drawTeamB.mean - teamB.mean

    #expect(decisiveChangeB < 0)
    #expect(drawChangeB < 0)
    #expect(decisiveChangeB > drawChangeB)

    let decisiveTeamC = decisiveResult.teams[2][0]
    let drawTeamC = drawResult.teams[1][1]

    let decisiveChangeC = decisiveTeamC.mean - teamC.mean
    let drawChangeC = drawTeamC.mean - teamC.mean

    #expect(decisiveChangeC > 0)
    #expect(drawChangeC > 0)
    #expect(decisiveChangeC < drawChangeC)

    let decisiveTeamD = decisiveResult.teams[3][0]
    let drawTeamD = drawResult.teams[2][0]

    let decisiveChangeD = decisiveTeamD.mean - teamD.mean
    let drawChangeD = drawTeamD.mean - teamD.mean

    #expect(decisiveChangeD < 0)
    #expect(drawChangeD < 0)
    #expect(decisiveChangeD < drawChangeD)
  }
}
