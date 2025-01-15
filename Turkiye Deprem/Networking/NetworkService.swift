//
//  NetworkService.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 13.01.2025.
//

import Combine
import Foundation
import SwiftSoup

class NetworkService {
    private func formatTarih(_ tarih: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        guard let date = dateFormatter.date(from: tarih) else { return tarih }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let dateToCheck = calendar.startOfDay(for: date)

        if calendar.isDate(dateToCheck, inSameDayAs: today) {
            return "Bugün"
        } else if calendar.isDate(dateToCheck, inSameDayAs: yesterday) {
            return "Dün"
        } else {
            return dateFormatter.string(from: date)
        }
    }

    func fetchDepremHtmlData() -> AnyPublisher<Result<String, Error>, Never> {
        guard let url = URL(string: Constants.BASE_URL) else {
            return Just(.failure(NetworkError.invalidURL))
                .eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard
                    let htmlString = String(
                        data: data, encoding: .windowsCP1254)
                else {
                    guard
                        let isoString = String(data: data, encoding: .isoLatin1)
                    else {
                        throw NetworkError.invalidData
                    }
                    return isoString
                }

                let doc: Document = try SwiftSoup.parse(htmlString)
                return try doc.select("pre").text().trimmingCharacters(
                    in: .whitespacesAndNewlines)
            }
            .map { .success($0) }
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }

    func getDepremData() -> AnyPublisher<
        Result<[TurkiyeDepremModel], Error>, Never
    > {
        fetchDepremHtmlData()
            .map { result -> Result<[TurkiyeDepremModel], Error> in
                switch result {
                case .success(let data):

                    let lines = data.components(separatedBy: .newlines).filter {
                        !$0.isEmpty
                    }
                    let pattern =
                        #"(\d{4}\.\d{2}\.\d{2})\s+(\d{2}:\d{2}:\d{2})\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)\s+-\.-\s+([\d.-]+)\s+(.+?)\s+(İlksel|REVIZE\d+)"#

                    guard let regex = try? NSRegularExpression(pattern: pattern)
                    else {
                        return .failure(NetworkError.invalidRegex)
                    }

                    var depremListesi: [TurkiyeDepremModel] = []

                    for (index, line) in lines.enumerated() {
                        let range = NSRange(
                            location: 0, length: line.utf16.count)

                        if let match = regex.firstMatch(
                            in: line, options: [], range: range)
                        {
                            let tarih = (line as NSString).substring(
                                with: match.range(at: 1))
                            let saat = (line as NSString).substring(
                                with: match.range(at: 2))
                            let enlem =
                                Double(
                                    (line as NSString).substring(
                                        with: match.range(at: 3))) ?? 0.0
                            let boylam =
                                Double(
                                    (line as NSString).substring(
                                        with: match.range(at: 4))) ?? 0.0
                            let derinlik =
                                Double(
                                    (line as NSString).substring(
                                        with: match.range(at: 5))) ?? 0.0
                            let buyukluk =
                                Double(
                                    (line as NSString).substring(
                                        with: match.range(at: 6))) ?? 0.0
                            let yer = (line as NSString).substring(
                                with: match.range(at: 7))

                            let formatDate = {
                                let dateComponents = tarih.split(separator: ".")
                                guard dateComponents.count == 3 else {
                                    return tarih
                                }
                                return
                                    "\(dateComponents[2]).\(dateComponents[1]).\(dateComponents[0])"
                            }

                            let depremModel = TurkiyeDepremModel(
                                id: index,
                                tarih: self.formatTarih(formatDate()),
                                saat: saat,
                                enlem: enlem,
                                boylam: boylam,
                                derinlik: derinlik,
                                buyukluk: buyukluk,
                                yer: self.clearLocation(yer)
                            )

                            depremListesi.append(depremModel)
                        }
                    }

                    return .success(depremListesi)

                case .failure(let error):
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }

    private func clearLocation(_ yer: String) -> String {
        let pattern = #"^\s*[\d.-]+\s+|-.-\s+"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return yer
        }

        let range = NSRange(location: 0, length: yer.utf16.count)
        let cleanedLocation = regex.stringByReplacingMatches(
            in: yer,
            options: [],
            range: range,
            withTemplate: "")
        return cleanedLocation.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
